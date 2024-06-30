require "spec_helper"

describe Releases::Parse do
  HUGE_EXAMPLE = {
    draft: false,
    prerelease: false,
    tag_name: "v11.0.1",
    assets: [
      {
        browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v11.0.1/farmlab-rpi-11.0.1.fw",
        content_type: "application/octet-stream",
        name: "farmlab-rpi-11.0.1.fw",
        state: "uploaded",
      },
      {
        browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v11.0.1/farmlab-rpi-11.0.1.img",
        content_type: "application/octet-stream",
        name: "farmlab-rpi-11.0.1.img",
        state: "uploaded",
      },
      {
        browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v11.0.1/farmlab-rpi-11.0.1.sha256",
        content_type: "application/octet-stream",
        name: "farmlab-rpi-11.0.1.sha256",
        state: "uploaded",
      },
      {
        browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v11.0.1/farmlab-rpi3-11.0.1.fw",
        content_type: "application/octet-stream",
        name: "farmlab-rpi3-11.0.1.fw",
        state: "uploaded",
      },
      {
        browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v11.0.1/farmlab-rpi3-11.0.1.img",
        content_type: "application/octet-stream",
        name: "farmlab-rpi3-11.0.1.img",
        state: "uploaded",
      },
      {
        browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v11.0.1/farmlab-rpi3-11.0.1.sha256",
        content_type: "application/octet-stream",
        name: "farmlab-rpi3-11.0.1.sha256",
        state: "uploaded",
      },
    ],
  }

  it "parses a release" do
    input = {
      draft: false,
      prerelease: false,
      tag_name: "v12.1.0",
      assets: [
        {
          name: "farmlab-rpi-12.1.0.fw",
          content_type: "application/octet-stream",
          state: "uploaded",
          browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi-12.1.0.fw",
        },
        {
          name: "farmlab-rpi-12.1.0.img",
          content_type: "application/octet-stream",
          state: "uploaded",
          browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi-12.1.0.img",
        },
        {
          name: "farmlab-rpi-12.1.0.sha256",
          content_type: "application/octet-stream",
          state: "uploaded",
          browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi-12.1.0.sha256",
        },
        {
          name: "farmlab-rpi3-12.1.0.fw",
          content_type: "application/octet-stream",
          state: "uploaded",
          browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi3-12.1.0.fw",
        },
        {
          name: "farmlab-rpi3-12.1.0.img",
          content_type: "application/octet-stream",
          state: "uploaded",
          browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi3-12.1.0.img",
        },
        {
          name: "farmlab-rpi3-12.1.0.sha256",
          content_type: "application/octet-stream",
          state: "uploaded",
          browser_download_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi3-12.1.0.sha256",
        },
      ],
    }
    output = Releases::Parse.run!(input)
    expect(output.count).to be 2
    expect(output).to include({
                        image_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi-12.1.0.fw",
                        version: "12.1.0",
                        platform: "rpi",
                      })
    expect(output).to include({
                        image_url: "https://github.com/LeeSSXX/farmlab_os/releases/download/v12.1.0/farmlab-rpi3-12.1.0.fw",
                        version: "12.1.0",
                        platform: "rpi3",
                      })
  end

  it "refuses to parse drafts" do
    boom = -> do
      Releases::Parse.run!({ draft: true, prerelease: false, tag_name: "11.0.1", assets: [] })
    end
    expect(boom).to raise_error(Mutations::ValidationException, "Don't publish drafts.")
  end

  it "double checks the platform detection regex" do
    boom = -> do
      Releases::Parse.run!({
        draft: false,
        prerelease: false,
        tag_name: "11.0.1",
        assets: [
          {
            browser_download_url: "whatever.fw",
            content_type: "application/octet-stream",
            name: "farmlab-bbb3-11.0.1.fw", # <== Intentionally wrong format.
            state: "uploaded",
          },
        ],
      })
    end

    expect(boom).to raise_error("Invalid platform?: bbb3")
  end
end
