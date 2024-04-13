mod cli;
mod create;
mod error;

use crate::cli::{Args, Commands};
use crate::error::SrError;
use clap::Parser;

fn run(args: Args) -> Result<(), SrError> {
    match &args.command {
        Commands::Create => create::create(),
    }
}

fn main() {
    let args = Args::parse();
    match run(args) {
        Ok(()) => {}
        Err(e) => {
            eprintln!("[ERROR]: {}", e);
            std::process::exit(1);
        }
    }
}
