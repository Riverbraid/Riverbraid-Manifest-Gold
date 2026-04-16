# Update Ceremony Protocol (Linear Gate)

The cluster must remain in QUARANTINE until 23/23 LOCKED.

1. Update Manifest-Gold with new root (Intent)
2. All petals immediately fail-closed on next verify-all.sh (Quarantine)
3. Sequentially update each petal's runtime-binding.js and .anchor.asc
4. Manually GPG-sign the new .anchor in each petal
5. Run ./verify-all.sh
6. Only when 23/23 LOCKED is the cluster considered STATIONARY again

During transition the entire cluster is OFFLINE by design.
