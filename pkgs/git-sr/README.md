# git-sr

My workflow for managing stacked git reviews, where each commit should have a separate merge request.

TODO: should this be dependent on `git-branchless`?

## Workflow

1. Commit multiple changes to a branch.
1. Push the branch to the remote.
1. Call `git sr create`.
1. git-sr will ask for a root commit, specifying the master as default.
1. git-sr will ask for a prefix for the merge request branches. They will be created as `<PREFIX>-sreview-1`, `<PREFIX>-sreview-2`, etc.
1. git-sr will preview all merge requests you would like to create and ask for confirmation. Following the confirmation, it will do the following.
    1. Create a new branch for each commit.
    1. Push the branch to the remote.
    1. Create a merge request for each branch with a placeholder section in the description for the commit message. The request will be to merge into the previous branch.
    1. Update the commit message with the merge request URLs.

### Updating commits

When editing or rebasing, make sure to call rebase with the `--update-refs` flag. This will update the merge request branches with the new commits.

If you have edited the commit titles, you can call `git sr sync` again to update the merge request descriptions.

For the most ideal rebasing situation, use [git-branchless]().

### Cleaning up before merges

When merging in, you might want to remove the descriptions. You can do this by calling `git sr sanitize`. This will remove the sections with the review helpers.

You can also call sanitize on a single commit by calling `git sr sanitize <commit>`. This will remove the section from the commit message.

### Merging in

When merging in, you can either:
- Merge the merge requests in order.
- Merge the top-most merge request, after changing its target to the branch you want to merge into.
