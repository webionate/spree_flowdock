Deface::Override.new(
  virtual_path: 'spree/admin/shared/sub_menu/_configuration',
  name: 'add_flowdock_settings_link',
  insert_bottom: '[data-hook="admin_configurations_sidebar_menu"], #admin_configurations_sidebar_menu[data-hook]',
  text: "<%= configurations_sidebar_menu_item(t('flowdock.settings.link'), edit_admin_flowdock_settings_path) %>"
  )
