require "connection_adapter"

module ActiveRecord
  class Base
    @@connection = SqliteAdapter.new

    def initialize(attributes={})
      @attributes = attributes
    end

    def method_missing(name, *args)
      if self.class.columns.include?(name)
        @attributes[name]
      else
        super
      end
    end

    def self.find(id)
      find_by_sql("SELECT * FROM #{table_name} WHERE id = #{id.to_i} LIMIT 1").first
    end

    def self.find_by_sql(sql)
      rows = @@connection.execute(sql) # [ {id: 1, name: "Marc"} ]
      rows.map do |attributes|
        new attributes
      end
    end

    def self.columns
      @@connection.columns(table_name)
    end

    def self.table_name
      name.downcase + "s" # users
    end
  end
end