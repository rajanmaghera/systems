use git2;
use inquire::error::InquireError;
use std::fmt;

pub enum SrError {
    GitError(git2::Error),
    InquireError(InquireError),
    UnknownError,
    NotImplemented,
}

impl From<git2::Error> for SrError {
    fn from(e: git2::Error) -> Self {
        SrError::GitError(e)
    }
}

impl From<InquireError> for SrError {
    fn from(e: InquireError) -> Self {
        SrError::InquireError(e)
    }
}

impl From<SrError> for fmt::Error {
    fn from(_: SrError) -> Self {
        fmt::Error
    }
}

impl fmt::Display for SrError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            SrError::GitError(e) => write!(f, "Git error: {}", e),
            SrError::InquireError(e) => write!(f, "Inquire error: {}", e),
            SrError::UnknownError => write!(f, "Unknown error"),
            SrError::NotImplemented => write!(f, "Not implemented"),
        }
    }
}
