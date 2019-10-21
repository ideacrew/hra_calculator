module Transactions
  class LoadTranslations
    include Dry::Transaction(container: ::Registry)

    step :list_path, with: 'resource_registry.stores.list_path'
    step :load_dependencies

    private

    def list_path(_input)
      path = Registry.config.root.join('system', 'locales')
      super path
    end

    def load_dependencies(paths)
      translations = paths.collect do |path|
        result = Transactions::LoadLocale.new.call(path)
        result.value!
      end

      Success(translations)
    end
  end
end
