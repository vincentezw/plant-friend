# frozen_string_literal: true

# Application helper
module ApplicationHelper
  extend T::Sig

  sig { params(icon: String, options: T.nilable(T::Hash[Symbol, String])).returns(String) }
  def icon(icon, options = {})
    file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    svg['class'] += " #{options[:class]}" if options[:class].present?
    doc.to_html.html_safe
  end

  sig { params(task_type: String).returns(String) }
  def icon_for_task(task_type)
    icon = case task_type
           when ::Task::TaskActionType::Water.serialize.downcase
             'water'
           when ::Task::TaskActionType::Mist.serialize.downcase
             'droplet-half'
           when ::Task::TaskActionType::Clean.serialize.downcase
             'stars'
           when ::Task::TaskActionType::Fertilise.serialize.downcase
             'flower1'
           else
             'question'
           end
    icon(icon)
  end
end
