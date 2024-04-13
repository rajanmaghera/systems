use crate::error::SrError;
use git2::{BranchType, Commit, Repository, RepositoryOpenFlags, Tag};
use inquire::Select;
use std::fmt;

struct BranchWrapper<'a>(git2::Branch<'a>);

impl fmt::Display for BranchWrapper<'_> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "{}",
            self.0
                .name()
                .unwrap_or(Some("<unknown>"))
                .unwrap_or("<unknown>")
        )
    }
}

pub fn create() -> Result<(), SrError> {
    // Open the current directory as a git repository
    let repo = Repository::open_ext(
        ".",
        RepositoryOpenFlags::empty(),
        &[] as &[&std::ffi::OsStr],
    )?;

    // Find the local branches in the repository
    let branches = repo
        .branches(Some(BranchType::Local))?
        .map(|branch| Ok(BranchWrapper(branch?.0)))
        .collect::<Result<Vec<_>, git2::Error>>()?;

    // Get the commit tag from the user
    let tag = Select::new("Enter the root commit tag", branches)
        .with_help_message("This is the tag that will be used to create the branch")
        .prompt()?;

    // Ask user for a branch name prefix
    let prefix = inquire::Text::new("Enter the branch name prefix")
        .with_help_message("This is the prefix that will be used to create the branch")
        .prompt()?;

    // Get head commit
    let head = repo.head()?;

    // Get revlist from head to tag
    let mut revwalk = repo.revwalk()?;
    revwalk.push_head()?;
    revwalk.hide(tag.0.get().target().ok_or(SrError::UnknownError)?)?;

    let oids = revwalk.collect::<Result<Vec<_>, git2::Error>>()?;

    // Get commits from oids
    let commits = oids
        .into_iter()
        .map(|oid| oids.try_into())
        .collect::<Result<Vec<Commit<'_>>, git2::Error>>();

    dbg!(oids);

    Err(SrError::NotImplemented)
}
