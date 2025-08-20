# lib/test_broadcast.rb
# Utilisez ce script dans rails console pour tester le broadcast

def test_order_broadcast
  order_id = "CMD-#{rand(1000..9999)}"

  fake_order = {
    order_id: order_id,
    table_number: "Table #{rand(1..20)}",
    created_at: Time.current.iso8601,
    currency: "TND",
    notes: "Commande test générée automatiquement",
    items: [
      {
        name: "Pizza Margherita",
        qty: 2,
        category: "plat",
        unit_price_cents: 1200,
        notes: "Sans olives",
        sauces: [ "ketchup" ],
        legumes: [ "tomate", "basilic" ],
        supplements: []
      },
      {
        name: "Coca Cola",
        qty: 1,
        category: "boisson",
        unit_price_cents: 300,
        notes: "",
        sauces: [],
        legumes: [],
        supplements: [ "glaçons" ]
      }
    ],
    receipt: {
      order_id: order_id,
      table_number: "Table #{rand(1..20)}",
      total: 2700, # (2 * 1200) + (1 * 300)
      currency: "TND",
      lines: [
        { name: "Pizza Margherita", qty: 2, unit_price_cents: 1200, total_cents: 2400 },
        { name: "Coca Cola", qty: 1, unit_price_cents: 300, total_cents: 300 }
      ]
    }
  }

  puts "🚀 Broadcasting fake order: #{fake_order[:order_id]}"
  puts "📊 Items: #{fake_order[:items].map { |i| "#{i[:qty]}x #{i[:name]}" }.join(', ')}"
  puts "💰 Total: #{fake_order[:receipt][:total]} centimes (#{fake_order[:receipt][:total]/100.0} TND)"

  # IMPORTANT: Utiliser le même stream que dans OrdersChannel
  ActionCable.server.broadcast("orders_stream", fake_order)
  puts "✅ Broadcast sent to 'orders_stream'!"
  puts "🎯 Vérifiez Electron pour voir si la commande est reçue et imprimée"
end

# Dans rails console, tapez:
# load 'lib/test_broadcast.rb'
# test_order_broadcast
