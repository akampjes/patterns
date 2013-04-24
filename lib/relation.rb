module ActiveRecord
  class Relation
    attr_accessor :where_values

    def initialize(klass)
      @klass = klass
      @where_values = []
    end

    def where(values)
      relation = clone
      relation.where_values += [values]
      relation
    end

    def to_sql
      sql = "SELECT * FROM #{@klass.table_name}"
      sql << " WHERE " + @where_values.join(" AND ") if @where_values.any?
      sql
    end

    def to_a
      @klass.find_by_sql(to_sql)
    end

    def method_missing(method, *args, &block)
      if Array.method_defined?(method)
        to_a.send(method, *args, &block)
      else
        super
      end
    end
  end
end