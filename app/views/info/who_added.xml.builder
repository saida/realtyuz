xml.user_list(:for_property => @property.id) do
  for u in users
    xml.user do
      xml.fname(u.fname)
      xml.lname(u.lname)
      xml.email(u.email)
    end
  end
end