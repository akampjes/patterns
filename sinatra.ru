Routes = {
  "GET" => {}
}

def get(path, &block)
  Routes["GET"][path] = block
end

run -> env do
  method = env["REQUEST_METHOD"]
  path = env["PATH_INFO"]
  body = Routes[method][path].call
  [200, {'Content-Type' => 'text/plain'}, [body]]
end


get "/" do
  "awesome!"
end
