# LVFS firmware packaging for SHIFTphone 8 (otter)

Packaging the SHIFTphone 8 (otter) bootloader firmware for [fwupd](https://fwupd.org) and [LVFS](https://fwupd.org/lvfs) as CAB files.<br>
These CAB files are uploaded to LVFS by SHIFT for distribution.<br>
Users can install the latest bootloader through fwupd.

## Upgrading

```
sudo fwupmgr upgrade
```

## Preparing for a new release

1) Open `generate-cab-files` and edit the entries contained within `Image information (edit this)`
2) Run the cab generation script
3) Manually verify the output is correct and do QA

## Generating CAB files

```
bash generate-cab-files.sh
```

## License

See [LICENSE](./LICENSE).

Copyright (c) Dylan Van Assche (2021-2022)<br>
Copyright (c) SHIFT GmbH (2022-2024)
