class Cart < ApplicationRecord
  # before_destroy :not_referenced_by_any_order_item
  has_many :order_items
  has_many :line_items, dependent: :destroy

  # An Id is not required
  # belongs_to :order_items, optional: true
  belongs_to :users, optional: true

  # Need to pass in all the attribs from Item upwards
  def add_item(item, current_user_id, item_price, item_name, type)
    current_item = line_items.find_by(price: item_price, 
                                      user_id: current_user_id, 
                                      item_id: item.id,
                                      name: item_name,
                                      item_type: type)

    # build the line item based on current item
    if current_item
      current_item = line_items.build(
        price: item_price,
        user_id: current_user_id,
        item_id: item.id,
        name: item_name,
        item_type: type
      )
      self.update(user_id: current_user_id)
    else
      current_item = line_items.build(
        price: item_price,
        user_id: current_user_id,
        item_id: item.id,
        name: item_name,
        item_type: type
      )
      self.update(user_id: current_user_id)
    end

    # if current_item
    #   # current_item.increment(:quantity)
    # else
    #   current_item = line_items.build(item_id: item.id)
    # end

    current_item
  end

  # def not_referenced_by_any_order_item
  #   unless order_items.empty?
  #     errors.add(:base, "Order items present")
  #     throw :abort
  #   end
  # end

  STATE_TAX = 0.06

  # Get the total price
  def total_price
    total_price = line_items.to_a.sum { |item| item.total_price }
    total_price
  end

  def tax_on_price
    total_price = line_items.to_a.sum { |item| item.total_price }
    return total_price * STATE_TAX
  end

  def total_price_with_tax
    total_price = line_items.to_a.sum { |item| item.total_price }
    total_price_with_tax = total_price + tax_on_price
    return total_price_with_tax
  end

  def update_cart_price_attributes(total_price, total_price_with_tax)
    # self.write_attribute(price: total_price)
    self.update(tax: tax_on_price,
                total: total_price, 
                total_with_tax: total_price_with_tax)
  end

  def update_user_attribute
    self.update(user_id: line_item.user_id)
  end

  # def update_cart_price_with_tax(total_price_with_tax)
  #   self.update(total_with_tax: total_price_with_tax)
  # end
end
