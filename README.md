# SHIFT6mq LVFS firmware packaging

Packaging the SHIFT6mq bootloader firmware for [fwupd](https://fwupd.org) and [LVFS](https://fwupd.org/lvfs) as CAB files.<br>
These CAB files are uploaded to LVFS by SHIFT for distribution.<br>
Users can install the latest bootloader through fwupd.

## Upgrading

```
sudo fwupmgr upgrade
```

## Preparing for a new release

1) Open `generate-cab-files` and edit the entries contained within `Image information (edit this)`
2) Open `metainfo.xml` and update the `description` section
3) Run the cab generation script
4) Manually verify the output is correct and do QA

## Generating CAB files

```
bash generate-cab-files.sh
```

## License

See [LICENSE](./LICENSE).

Copyright (c) Dylan Van Assche (2021-2022)<br>
Copyright (c) SHIFT GmbH (2022)
