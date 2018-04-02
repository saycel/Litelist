defmodule Litelist.Schedulers.RemoveOldPosts do
    import Ecto.Query, warn: false
    use Timex

    alias Litelist.Posts

    def run() do
        Posts.delete_expired_posts()        
    end
end