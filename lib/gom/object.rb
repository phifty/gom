
module GOM

  module Object

    autoload :Injector, File.join(File.dirname(__FILE__), "object", "injector")
    autoload :Inspector, File.join(File.dirname(__FILE__), "object", "inspector")
    autoload :Mapping, File.join(File.dirname(__FILE__), "object", "mapping")

    def self.id(object)
      Mapping.id_by_object object
    end

  end

end
