defmodule Litelist.Schedulers.RemoveOldPosts do
    import Ecto.Query, warn: false
    use Timex
    alias Litelist.Repo
    alias Litelist.Posts.Post

    def run() do
        IO.inspect "Running From RemoveOldPosts..."

        # delete_posts_past_their_end_date()
        # delete_posts_past_their_end_time()
        # delete_old_posts_past_cutoff()

        
    end

    defp delete_posts_past_their_end_date() do
        today = Timex.today
        query = from p in Post, where: p.end_date < ^today
        Repo.delete_all(query)
    end

    defp delete_posts_past_their_end_time() do
        now = Timex.now
        query = from p in Post, where: p.end_time < ^now
        Repo.delete_all(query)
    end

    defp delete_expired_posts() do
        time_limit = 30
        now = Timex.now
        today = Timex.today
        date_cutoff = Timex.shift(now, days: -time_limit)

        query = from p in Post,
            where: p.inserted_at < ^date_cutoff and is_nil(p.end_time) and is_nil(p.end_date) or p.end_date < ^today,
            or_where: p.inserted_at < ^date_cutoff and is_nil(p.end_date) and is_nil(p.end_time) or p.end_time < ^now,
            or_where: p.inserted_at < ^date_cutoff and p.end_time < ^now and p.end_date < ^today,
            or_where: p.inserted_at < ^date_cutoff and is_nil(p.end_time) and is_nil(p.end_date),
            or_where: p.end_time < ^now and is_nil(p.end_time),
            or_where: p.end_date < ^today and is_nil(p.end_date),
            or_where: p.end_time < ^now and p.end_date < ^today

        Repo.delete_all(query)
    end
end