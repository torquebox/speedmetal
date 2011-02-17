run lambda { |env| 
  sleep(0.1)
  [200, { 'Content-Type' => 'text/html' }, "hello world"] 
}
