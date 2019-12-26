Redmine::Plugin.register :redmine_plantuml_integration do
  name 'Redmine Plantuml Integration'
  author 'Nikolay Punin'
  description 'Adding integration with plantuml online server into wiki/issue.'
  version '0.0.1'
  url 'https://github.com/png-tech/redmine_plantuml_integration'
  author_url 'https://github.com/png-tech'

  settings partial:'settings/plantuml',
           default: {
               'plantuml_server_url' => ''
           }
  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render PlantUML image.
      <pre>
      {{plantuml
      (Bob -> Alice : hello)
      }}
      </pre>

      Available options are:
      ** (png|svg)
EOF
    macro :plantuml do |obj, args, text|
      raise 'No PlantUML Server URL set.' if Setting.plugin_redmine_plantuml_integration['plantuml_server_url'].blank?
      uml_code = PlantUmlHelper.plantuml(text)
      image_tag "#{Setting.plugin_redmine_plantuml_integration['plantuml_server_url']}/png/#{uml_code}"
    end
  end
end
