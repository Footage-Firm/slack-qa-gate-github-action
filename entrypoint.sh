#!/bin/sh -l

set -eu

SLACK_BOT_TOKEN="${1?Must provide slack bot token}"
SLACK_CHANNEL_NAME="${2?Must provide slack channel ID}"
SLACK_MESSAGE_TS="${3?Must provide slack message timestamp}"

APP_ENDPOINT="${4?Must provide app endpoint}"
APP_NAME="${5?Must provide app name}"

COMMIT_MESSAGE_SUBJECT="${6?Must provide commit message subject}"
COMMITTER_NAME="${7?Must provide committer name}"
COMMIT_SHA="${8?Must provide commit sha}"
COMMIT_SHA_SHORT="$(echo "$COMMIT_SHA" | head -c 10)"


curl -X POST https://slack.com/api/chat.update \
  -H "Content-type: application/json; charset=utf-8" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  --data-binary @- << EOF
{
  "channel": "$SLACK_CHANNEL_NAME",
  "ts": "$SLACK_MESSAGE_TS",
  "icon_emoji": ":github-actions:",
  "blocks": [
    {
      "block_id": "header",
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*<https://github.com/$GITHUB_REPOSITORY/actions|[$APP_NAME] deployed to staging>* :rocket:"
      }
    },
    {
      "block_id": "prompt",
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Is your release ready to proceed to production?*"
      }
    },
    {
      "block_id": "commit",
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Commit*: $COMMIT_MESSAGE_SUBJECT"
      }
    },
    {
      "block_id": "committer_name",
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Committer*: $COMMITTER_NAME"
      }
    },
    {
      "block_id": "commit_sha",
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Sha*: $COMMIT_SHA_SHORT (<https://github.com/$GITHUB_REPOSITORY/$COMMIT_SHA|Details>)"
      }
    },
    {
      "block_id": "divider_1",
      "type": "divider"
    },
    {
      "block_id": "qa_gate_release_actions",
      "type": "actions",
      "elements": [
        {
          "type": "button",
          "text": {
            "type": "plain_text",
            "text": "View Endpoint :mag:",
            "emoji": true
          },
          "value": "view_endpoint",
          "url": "$APP_ENDPOINT"
        },
        {
          "type": "button",
          "text": {
            "type": "plain_text",
            "text": "Approve :white_check_mark:",
            "emoji": true
          },
          "value": "approve_release"
        },
        {
          "type": "button",
          "text": {
            "type": "plain_text",
            "text": "Reject :x:",
            "emoji": true
          },
          "value": "reject_release"
        },
        {
          "type": "overflow",
          "options": [
            {
              "text": {
                "type": "plain_text",
                "text": "Rollback",
                "emoji": true
              },
              "value": "rollback"
            }
          ],
          "action_id": "overflow-action"
        }
      ]
    }
  ]
}
EOF
