use clap::{Parser, Subcommand};

/// Rajan's command line tool
#[derive(Parser, Debug)]
#[command(author, version, about, long_about= None)]
pub struct Args {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand, Debug)]
pub enum Commands {
    /// Switch to this home manager config
    SwitchHm {
        /// The name of the home manager config
        name: String,
    },
}
