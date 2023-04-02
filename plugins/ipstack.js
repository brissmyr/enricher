function ipstack(event, context) {
  const ip = event.properties.custom_ip;
  const access_key = 'YOUR_ACCESS_KEY';
  const response = context.request(`http://api.ipstack.com/${ip}`, {
    params: { access_key: access_key },
  })

  return response;
}
