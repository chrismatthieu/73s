module StatusesHelper
  def status_counter
     update_page do |page|
        page << "$('counter_box').innerHTML = 150 - $('status_input_box').value.length"
     end
  end
end
