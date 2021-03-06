defmodule GithubService.Github.GetUserRepositories do
  alias GithubService.Github.TransformReposResponse
  alias GithubService.Github.Storage
  @client Application.get_env(:github_service, :client)

  def execute(username) do
    Storage.find_all_for_user(username)
    |> retrieve_repositories(username)
  end

  defp retrieve_repositories([], username) do
    all_repos = @client.get_repositories_for(username)
    |> TransformReposResponse.convert

    Enum.each(all_repos, fn(r) -> Storage.write_repository(r) end)

    all_repos
  end
  defp retrieve_repositories(repos, _username), do: repos
end

