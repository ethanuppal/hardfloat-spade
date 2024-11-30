import platform
import subprocess
import sys


def main():
    os_name = platform.system().lower()

    if os_name == "linux":
        script = "setup/ubuntu.sh"
    elif os_name == "darwin":
        script = "setup/macos.sh"
    else:
        print("Error: Unsupported operating system.")
        sys.exit(1)

    try:
        subprocess.run(["chmod", "+x", script], check=True)
        subprocess.run(["/bin/sh", script], check=True)
    except subprocess.CalledProcessError as error:
        print(f"Error: Failed to run {script}: {error}.")
        sys.exit(1)


if __name__ == "__main__":
    main()
