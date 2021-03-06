module Meteor
  module Widget
    module NamedCell
      class Spec < ::Meteor::ModelSpecBase
        attr_accessor :rows
        attr_accessor :column_hash
        attr_accessor :max_columns

        def self.renderer_class
          Renderer
        end

        def find_by_cell_name(name)
          find_cell_by_name(name)
        end

        def find_cell_by_name(name)
          column_hash[name]
        end

        def initialize(h={},&block)
          self.rows = []
          self.column_hash = {}

          super(h,&block)

          rows.each do |row|
            row.cell_list.each do |cell|
              self.column_hash[cell.name] = cell
            end
          end
        end

        def max_columns
          if @max_columns.nil?
            @max_columns = 0
            rows.each do |row|
              _t = row.cell_list.length
              @max_columns = _t if _t > @max_columns
            end
          end
          @max_columns
        end
      end
    end
  end
end
