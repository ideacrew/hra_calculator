# frozen_string_literal: true

require 'dry-types'
Dry::Types.load_extensions(:maybe)

module Types
  include Dry::Types(default: :nominal)

  LowCostPlan     = Types::Coercible::Symbol.enum(:lowest_cost_silver_plan, :second_lowest_cost_silver_plan)
  CallableDate    = Types::Date.default { Date.today }

  RequiredSymbol  = Types::Strict::Symbol.constrained(min_size: 2)
  RequiredString  = Types::Strict::String.constrained(min_size: 1)

  StrippedString  = String.constructor(->(val){ String(val).strip })
  Email           = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)

  EmailOrString   = Types::Email | Types::String
  SymbolOrString  = Types::Symbol | Types::String
  NilOrString     = Types::Nil | Types::String

  Callable   = Types.Interface(:call)
  Duration   = Types.Constructor(:build, ->(val){ ActiveSupport::Duration.build(val) })
  Path       = Types.Constructor(:build, ->(val){ val.is_a?(Pathname) ? val : Pathname.new(val) })

end
