module StatusesHelper
  def status_counter
     update_page do |page|
        page << "$('counter_box').innerHTML = 140 - $('status_input_box').value.length"
     end
  end
end
