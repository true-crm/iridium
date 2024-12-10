require 'active_support/core_ext/class/attribute'

module Iridium
  # A placeholder for iridium specific components
  class Component < Hydrogen::Component 
    ABSTRACT_COMPONENTS = %w(Iridium::Component Iridium::Engine Iridium::Application)

    class << self
      def loaded
        Hydrogen::Component.loaded
      end

      def subclasses
        loaded.select { |f| f <= self }
      end

      def inherited(base)
        return if base.abstract?

        super
        base.called_from = File.dirname(caller.detect { |l| l !~ /lib\/iridium/ })
      end

      def abstract?
        ABSTRACT_COMPONENTS.include?(name)
      end

      def initializer(*args, &block)
        callback :initialize, *args, &block
      end

      def callback(set, *args, &block)
        options = args.last.is_a?(Hash) ? args.pop : {}

        options[:class] = self
        args << options
        super set, *args, &block
      end
    end
  end
end
