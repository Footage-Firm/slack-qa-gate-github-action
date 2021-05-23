# Slack QA Gate Github Action

An opinionated Github action that posts a Slack message containing deployment information and buttons that allow for rejection or approval of the release.

## Usage

```yaml
jobs:
  deploy_staging:
    runs-on: ubuntu-latest
    env:
      STAGING_ENDPOINT: "https://staging-endpoint.foo.com"
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Expose git commit data
        uses: rlespinasse/git-commit-data-action@v1.x

      - name: Deploy to staging
        run: |
          Do your deploy

      - name: Notify slack
        uses: Footage-Firm/slack-qa-gate-github-action@1.0.0
        with:
          slack_bot_token: ${{ secrets.SLACK_BOT_TOKEN }}
          slack_channel_name: "some-deployment-channel"
          app: ${{ github.repository }}
          commit_message_subject: ${{ env.GIT_COMMIT_MESSAGE_SUBJECT }}
          committer_name: ${{ env.GIT_COMMIT_AUTHOR_NAME }}
          commit_sha: ${{ github.sha }}
          endpoint: ${{ env.STAGING_ENDPOINT }}
```
