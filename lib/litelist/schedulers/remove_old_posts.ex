defmodule Litelist.Schedulers.RemoveOldPosts do
    import Ecto.Query, warn: false
    use Timex

    alias Litelist.Posts

    def run() do
        IO.inspect "Running From RemoveOldPosts..."
        Posts.delete_expired_posts()
        # delete_posts_past_their_end_date()
        # delete_posts_past_their_end_time()
        # delete_old_posts_past_cutoff()

        
    end
end