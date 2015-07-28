require 'anima'

module ROM
  class Repository
    class StructBuilder
      attr_reader :registry

      def self.registry
        @__registry__ ||= {}
      end

      def initialize
        @registry = self.class.registry
      end

      def call(name, columns)
        # TODO: figure out how to generate unique identifiers for struct classes
        registry[columns] ||=
          begin
            ROM::ClassBuilder.new(name: "ROM::Struct[#{component_name(name)}]", parent: Object).call do |klass|
              klass.send(:include, Anima.new(*columns))
            end
          end
      end
      alias_method :[], :call

      def component_name(name)
        Inflector.classify(Inflector.singularize(name))
      end
    end
  end
end