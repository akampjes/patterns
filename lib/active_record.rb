require "connection_adapter"
require "active_model"
require "relation"

module ActiveRecord
  class Base
    include ActiveModel::Validations

    @@connection = SqliteAdapter.new

    def initialize(attributes={})
      @attributes = attributes
    end

    def method_missing(name, *args)
      if self.class.attribute_methods_generated?
        super
      else
        self.class.define_attribute_methods

        if self.class.columns.include?(name)
          send name
        else
          super
        end
      end
    end

    def self.define_attribute_methods
      columns.each do |column|
        class_eval <<-EOS
          def #{column}
            @attributes[:#{column}]
          end
        EOS
      end
      @attribute_methods_generated = true
    end

    def self.attribute_methods_generated?
      @attribute_methods_generated
    end

    # def name
    #   @attributes[:name]
    # end

    def self.find(id)
      find_by_sql("SELECT * FROM #{table_name} WHERE id = #{id.to_i} LIMIT 1").first
    end

    def self.all
      find_by_sql("SELECT * FROM #{table_name}")
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

    
    #### Relation

    def self.all
      current_scope || Relation.new(self)
    end

    def self.where(values)
      all.where(values)
    end

    class << self
      attr_accessor :current_scope
    end

    def self.scope(name, body)
      define_singleton_method name, &body
    end
  end
end