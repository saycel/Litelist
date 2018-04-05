defmodule Litelist.Schedulers.RemoveOldPosts do
    @moduledoc """
    Scheduler that can remove expired posts at a regular interval
    """
    import Ecto.Query, warn: false
    use Timex

    alias Litelist.Posts

    def run() do
        Posts.delete_expired_posts()        
    end
end