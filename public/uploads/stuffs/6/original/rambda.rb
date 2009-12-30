
class Var 
  attr_accessor :func #back ref to the function
  def inspect
    #allow free var for convience
    if func then
     func.var_name
    else
     "F"            
    end
  end
end

class Func 
  attr_accessor :vars, :body
  def initialize 
    @vars = []
  end
  
  @@next_name = -1
  def var_name
    @var_name or 
    @var_name = (('a'..'z').to_a)[@@next_name += 1] or 
    @var_name = 'v' + (@@next_name-26).to_s
  end
  
  def inspect
    "(^#{var_name}.#{body.inspect})"
  end
end

class App 
  attr_accessor :exp1, :exp2
  
  def initialize e1, e2
    @exp1,@exp2 = e1,e2
  end
  
  def inspect
    "(#{exp1.inspect}*#{exp2.inspect})"
  end
end

# parse a string s into a lambda expression
# <exp> -> <var> | <func> | <app> | (<exp>)
# <var> -> ID
# <func> -> ^ID.<exp>
# <app> -> <exp>*<exp>
$tobind = []

  
  def Exp s
    exp = Exp1 s
    while s.sub!(/^\s*\*\s*/,'')
      exp = App.new(exp, (Exp1 s))
      
    end
    exp
  end
  
  def Exp1 s
      if s.sub!(/^\s*\(\s*/, '') then
        exp = Exp s
        throw "missing matching ) at #{s}" unless s.sub!(/^\s*\)\s*/, '')
        exp 
      elsif s.sub!(/^\s*\^\s*/, '') then 
        Func s
      elsif #the expression is variable, bind it to its function
        s.sub!(/^\s*(\w+)\s*/, '')
        throw "expecting an ID" unless $1
        var = Var.new
        p = $tobind.reverse.find {|x| x[0]==$1 }
        throw "can't bind variable #{$1}" unless p
        var.func = p[1]
        p[1].vars.push var
        var
      else
        throw "unexpected: #{s}"
      end
    
  end
  
  # parse <func>, beginning from id
  def Func s
    func = Func.new
    throw "expecting ^ID.<exp>" unless s.sub!(/^\s*(\w+)\s*\./, '')
    $tobind.push [$1, func]
    func.body = Exp s
    $tobind.pop
    func
  end

def parse s
  exp = Exp s
  s.rstrip!
  throw "unexpected #{s}" if !s.empty?
  exp
end

# deep copy
def Dup exp
  funcs = {} #mapping old functions to new ones
  def Dup_rec exp, funcs
    case exp.class.inspect
      when 'Var'
       newvar = Var.new
       #rebind
       newfunc = funcs[exp.func]
       newvar.func = newfunc
       newfunc.vars.push newvar
       newvar
      when 'App'
       App.new(Dup_rec(exp.exp1, funcs),
        Dup_rec(exp.exp2, funcs))
      when 'Func'
       newfunc = Func.new
       funcs[exp] = newfunc
       newfunc.body = Dup_rec(exp.body, funcs)
       newfunc
      else
        throw 'Dup: invalid expression type'
    end #case
  end #Dup_rec
  
  Dup_rec(exp, funcs)
end

# take an App whose exp1 is a Func
# return a new expression with  exp2 substituted into the body of exp1
def Substitute app, funcs = {}
  throw "expect an App whose first part is a Func" unless 
   app.class == App and app.exp1.class == Func
  
  def Sub_rec exp, vars, subst, funcs
    case exp.class.inspect
      when 'Var'
       if vars.include? exp then
         #substitute
         Sub_rec(subst, vars, subst, funcs)
       else
        #duplicate
        newvar = Var.new
        #rebind
        newfunc = funcs[exp.func]
        #allow free var for convience
        if newfunc then
         newvar.func = newfunc
         newfunc.vars.push newvar
        end
        newvar
       end
      when 'App'
       App.new(Sub_rec(exp.exp1, vars, subst, funcs),
        Sub_rec(exp.exp2, vars, subst,  funcs))
      when 'Func'
       newfunc = Func.new
       funcs[exp] = newfunc
       newfunc.body = Sub_rec(exp.body, vars, subst, funcs)
       newfunc
      else
        throw 'invalid expression type'
    end #case
  end #Sub_rec
  
  Sub_rec(app.exp1.body, app.exp1.vars, app.exp2, funcs)
end

def DeepSubstitute1 exp
  funcs = {} #mapping old functions to new ones
  substituted = []
  def DeepSub_rec exp, funcs, substituted
    case exp.class.inspect
      when 'Var'
       newvar = Var.new
       #rebind
       newfunc = funcs[exp.func]
       newvar.func = newfunc
       newfunc.vars.push newvar
       newvar
      when 'App'
       if exp.exp1.class == Func then
        substituted[0] = true
        Substitute(exp, funcs)
       else
        App.new(
         DeepSub_rec(exp.exp1, funcs, substituted),
         DeepSub_rec(exp.exp2, funcs, substituted))
       end      
      when 'Func'
       newfunc = Func.new
       funcs[exp] = newfunc
       newfunc.body = 
        DeepSub_rec(exp.body, funcs, substituted)
       newfunc
      else
        throw 'invalid expression type'
    end #case
  end #DeepSub_rec
  
  res = exp
  substituted[0] = true
  while substituted[0]
   substituted[0] = false
   res = DeepSub_rec(res, funcs, substituted)
 end
 res
end

class DeepSubst
  def initialize
    @to_subst = {}
  end

  def DeepSubstRec exp
    #puts "stack depth #{caller.length} doing #{exp.inspect} subst#{@to_subst.inspect}"
    #gets
    case exp.class.inspect
      when 'Var'
        exp1 = exp
        while @to_subst.has_key? exp1
          exp1 = @to_subst[exp1]
        end
        exp1
      when 'Func'
        exp.body = DeepSubstRec exp.body
        exp
      when 'App'
        #todo: lazy eval
        exp2 = DeepSubstRec exp.exp2
        case exp.exp1.class.inspect 
          when 'Func'
            exp.exp1.vars.each{|x| @to_subst[x] = exp2}
            return DeepSubstRec(exp.exp1.body)
          when 'Var'
            exp1 = DeepSubstRec exp.exp1
            return App.new(exp1, exp2) if exp1.class == Var 
            return DeepSubstRec(App.new(exp1, exp2))
          else
            exp1 = DeepSubstRec exp.exp1
            return DeepSubstRec(App.new(exp1, exp2))
        end
    end
  end
end

def DeepSubstitute exp
  subster = DeepSubst.new
  subster.DeepSubstRec exp
end