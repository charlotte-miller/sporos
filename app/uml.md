g scaffold Ministry name:string description:text url_path:string --no-assets 
g models Involvement user:references ministry:references status:integer level:integer
g migration enable_hstore_extension
g scaffold Post type:text title:text description:text display_options:hstore poster:attachment expires_at:datetime --no-assets

g model Publication post:references user:references status:integer
g model Approval publication:references user:references status:integer 

#### STI Models
Events
Video
Photo
Link
Page