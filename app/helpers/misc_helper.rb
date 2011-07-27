module MiscHelper

  def include_category? category
    if params["include"].nil? && params["called_from_index"].nil?
      true
    elsif !params["include"].nil?
      params["include"].include?(category.id.to_s)
    end

  end

  def dout str
    puts "--------------------------<<-----------------------------"
    puts str
    puts "--------------------------<<-----------------------------"
  end

  def group
    if params["group_id"].nil? || params[:group_id] == ""
      Group.new()
    else
      Group.find(params[:group_id])
    end
  end

end
