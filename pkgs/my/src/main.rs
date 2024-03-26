mod cli;

use crate::cli::{Commands, Args};
use clap::Parser;
use exec::Command;

macro_rules! cmd {
    // Macro to exec command
    ($base:expr, $args:expr) => {
        Command::new($base).args($args).exec()
    };
}

fn main() {
    let args = Args::parse();
    match &args.command {
        Commands::SwitchHm { name } => {
            let _ = cmd!("nix", &["run", "home-manager/master", "--", "switch", "--flake", &format!(".#{}", &name)]);
        }
    }
}