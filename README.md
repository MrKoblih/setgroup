# /setgroup command

**Why am I releasing this?**

Because ESX 1.2 is not supporting essentialmode and es_admin and some scripts still depends on this (groups etc.: tag).



**Usage**

/setgroup [Target player ID] [Group]



**Available groups:**
- user
- mod
- admin
- superadmin



**Installation**:
First of all, lets remove the command /setgroup command from es_extended

- Open es_extended/server/commands.lua
- Remove the 125-130 line
- Download setgroup
- Edit name from setgroup-master to setgroup (or whatever ya want)
- Add the folder to your /resource folder
- Add start setgroup to your server.cfg
