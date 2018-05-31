class Order < ApplicationRecord
  # before_validation :set_total!
  # validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # belongs_to :user

  has_many :order_items, dependent: :destroy
  belongs_to :users, optional: true

  # add the cart to the order item
  def add_cart(cart)
    current_cart = order_items.find_by(cart_id: cart.id)

    if current_cart
      current_cart = order_items.build(cart_id: cart.id)
    else
      current_cart = order_items.build(cart_id: cart.id)
    end

    current_cart
  end

  def update_attribs(current_user_id, cart_subtotal, cart_total, cart_tax)
    self.update(tax: cart_tax,
                user_id: current_user_id,
                subtotal: cart_subtotal,
                total: cart_total)
  end


  # def tax_amount
  #   tax = 7.0 / 100.0
  #   tax
  # end

  # def set_subtotal
  #   self.subtotal = line_items.map(&:price).sum
  # end

  # def total_price_of_order
  #   self.total = subtotal_of_order * tax_amount
  # end

  # def set_total!
  #     self.total = products.map(&:price).sum
  # end
end
