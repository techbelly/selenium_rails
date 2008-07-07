module SeleniumRails
  module WithMethod
     def with(object, &block)
   	  object.instance_eval(&block)
     end
  end
end