module Meteor
  module Crud
    module Base
      def self.error_msg_html(e,error_div)
        error_msg = e.to_s
        if e.respond_to?(:backtrace)
          e.backtrace.each do |trace|
            error_msg += "\n#{trace}" if trace.match(/(app|meteor)/)
          end
        end
        %{
          <table id="warning_table">
            <tr>
              <td>
                <div id="warning_clear">
          	<a href="#"
              onclick="Effect.SlideUp('#{error_div}', { duration: 0.5 })">
              clear message
            </a>
                </div>
              </td>
              <td>
                <div id="warning_data">
                  <pre>
          	#{error_msg}
          	    <!-- Any sort of warning/alert messages go here -->
          	</pre>
                </div>
              </td>
            </tr>
          </table>

          <script>
          $('#{error_div}').show();
          </script>
          }

      end

      def meteor

        actionname = params["actionname"] # =>"add",
        id = params[:id] # =>"6088",
        widget_class = params[:widget_class]
        error_div = params[:error_div]
        indicator = params[:indicator]

        begin
          raise "no such variable :path found in params in #{current_method}" unless path = params[:path]

          spec_klass = "Meteor::Widget::#{widget_class}::Spec".constantize
          spec_name = path.split(/\./)[1]
          spec = spec_klass.find_by_path(:spec => meteor_spec(:name => spec_name),
                                         :path => path)
          
          raise "cannot find a meteor spec with name #{spec_name}." unless spec

          renderer_class = "Meteor::Widget::#{widget_class}::Renderer".constantize
          renderer = renderer_class.new(:spec => spec,
                                        :controller => self,
                                        :params => params,
                                        :frontend => widget_class.de_camelize,
                                        :id => id)

          # add param respond_to_parent to trigger this:
          if params.has_key?("respond_to_parent")
            responds_to_parent do
              render :update do |page|
                renderer.do_crud(actionname,page,params)
              end
            end
          else
            render :update do |page|
              renderer.do_crud(actionname,page,params)
            end
          end

        rescue Exception => e
          render :update do |page|
            page.replace_html error_div, Base.error_msg_html(e,error_div) if error_div
            page.show error_div if error_div
            page.hide indicator if indicator
          end
        end
      end
    end
  end
end
