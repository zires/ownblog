# Patch Paperclip flush_writes to close before move and reprocess! to use binary mode (for Windows compatibility)
module Paperclip
  module Storage
    module Filesystem
      def flush_writes #:nodoc:
        logger.info("[paperclip] Writing files for #{name}")
        @queued_for_write.each do |style, file|
          file.close
          FileUtils.mkdir_p(File.dirname(path(style)))
          logger.info("[paperclip] -> #{path(style)}")
          FileUtils.mv(file.path, path(style))
          FileUtils.chmod(0644, path(style))
        end
        @queued_for_write = {}
      end
    end
  end

  class Attachment
    def reprocess!
      new_original = Tempfile.new("paperclip-reprocess")
      new_original.binmode
      if old_original = to_file(:original)
        new_original.write( old_original.read )
        new_original.rewind
        @queued_for_write = { :original => new_original }
        post_process
        old_original.close if old_original.respond_to?(:close)
        save
      else
        true
      end
    end
  end
end