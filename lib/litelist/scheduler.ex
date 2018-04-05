defmodule Litelist.Scheduler do
    @moduledoc """
    Quantum is a library that allows for easy cron job creation
    """
    use Quantum.Scheduler,
        otp_app: :litelist
end