require.config
  paths:
    zooniverse: '.'

  shim:
    jQuery:
      deps: ['jquery']
      exports: 'jQuery'

    base64:
      exports: 'base64'

  deps: ['demo-setup']
