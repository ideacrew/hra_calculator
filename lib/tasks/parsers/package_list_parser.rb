require Rails.root.join('lib', 'tasks', 'parsers', 'package_parser')

module Parser
  class PackageListParser
    include HappyMapper

    tag 'packagesList'

    has_many :packages, Parser::PackageParser, tag: "packages"

    def to_hash
      {
        packages: packages.map(&:to_hash)
      }
    end
  end
end
