# Active Record extensions

require 'ckuru-tools'

module ActiveRecord
  class Base

    def self.find_only_one(*args)
      ret = find(*args)
      if ret.length == 1
        ret[0]
      elsif ret.length == 0
        nil
      else
        raise "#{current_method} found multiple record for #{args.inspect}"
      end
    end

    def self.find_all(h={})
      
      find_by_sql("select #{h[:distinct] ? 'distinct' : ''} * from #{table_name}")
    end

    def self.natural_key
      "#{table_name}_name"
    end

    #
    # If passed a string, looks up the canonical record (based on natural key).
    # Typically for "our" tables if the table_name is PERSON; it will be searching
    # basied on the PERSON_NAME field.
    #
    # If passed a non string; just calls activerecord find.
    #
    # Mostly syntactic sugar to alleviate type find_by_yadda_yadda_yadda which I hate to
    # type
    #
    # Example:
    #   MyClass.finder("Abe Lincoln") 
    #
    #   is equivalent to
    #
    #   MyClass.find_by_myclass_name("Abe Lincoln")
    #
    #   MyClass.finder(:myclass_name,"Abe  Lincoln") # hey why not!?
    #
    #   MyClass.finder(12) # just like .find()
    
    def self.finder(v,val=nil)
      ckebug 1, v.class if defined? ckebug
      if v.is_a? String
        self.send("find_by_#{natural_key}".to_sym,v)
      elsif v.class == Symbol
        self.send("find_by_#{v}".to_sym,val)
      else
        self.send(:find,v)
      end
    end

  end
end

ActiveScaffold::DataStructures::Column # force rails to load the class

class ActiveScaffold::DataStructures::Column
  def form_ui
    @association.nil? ? @form_ui : :select
  end
end
