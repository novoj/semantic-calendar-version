require "option_parser"

require "file_utils"

require "./semantic-calendar-version"

previous_version = false
dev_branch = "dev"
release_branch = "master"
minor_identifier = "/feat(\\([^)]+\\))?:/" # based on https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines
prefix = ""
log_paths = ""

folder = FileUtils.pwd

OptionParser.parse do |parser|
  parser.banner = "Usage: semantic-calendar-version; [arguments]"
  parser.on("-f FOLDER", "--folder=FOLDER", "Execute the command in the defined folder") { |f| folder = f }
  parser.on("-b BRANCH", "--dev-branch=BRANCH", "Specifies the development branch") { |branch| dev_branch = branch }
  parser.on("-r BRANCH", "--release-branch=BRANCH", "Specifies the release branch") { |branch| release_branch = branch }
  parser.on("--minor-identifier=IDENTIFIER",
    "Specifies the string or regex to identify a minor release commit with") { |identifier| minor_identifier = identifier }
  parser.on("-p PREFIX", "--version-prefix=PREFIX", "Specifies a version prefix") { |p| prefix = p }
  parser.on("-l PATH", "--log-paths=PATH", "") { |path| log_paths = path }
  parser.on("--previous-version", "Returns the previous tag instead of calculating a new one") { previous_version = true }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

git = SemanticCalendarVersion::Git.new(dev_branch, release_branch, minor_identifier, folder, prefix, log_paths)

if previous_version
  puts "#{git.get_previous_version}"
else
  puts "#{git.get_new_version}"
end
