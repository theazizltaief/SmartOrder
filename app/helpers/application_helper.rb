module ApplicationHelper
  # Formater les prix en dinars tunisiens
  def format_price_dt(millimes)
    return "0.000 DT" if millimes.nil? || millimes == 0

    dinars = millimes / 1000.0
    "#{number_with_precision(dinars, precision: 3, delimiter: ' ')} DT"
  end

  # Version courte pour l'affichage compact
  def format_price_dt_short(millimes)
    return "0 DT" if millimes.nil? || millimes == 0

    dinars = millimes / 1000.0
    if dinars == dinars.to_i
      "#{dinars.to_i} DT"
    else
      "#{number_with_precision(dinars, precision: 3, strip_insignificant_zeros: true)} DT"
    end
  end
end
