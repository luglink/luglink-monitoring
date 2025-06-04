#!/bin/bash

# Common variables
REGION="us-east-1"
API_NAME="LugLinkMatchAPI-REST"
STAGE="prod"
SNS_TOPIC_ARN="arn:aws:sns:us-east-1:913312012427:LugLinkAlarmsTopic"

echo "Deploying Error Threshold Alarm..."
aws cloudwatch put-metric-alarm \
  --alarm-name "LugLinkMatchAPI-ErrorThresholdExceeded" \
  --alarm-description "Triggers when API Gateway errors exceed 100 in 5 minutes" \
  --metric-name 5XXError \
  --namespace AWS/ApiGateway \
  --statistic Sum \
  --unit Count \
  --period 300 \
  --threshold 100 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --evaluation-periods 1 \
  --treat-missing-data notBreaching \
  --dimensions Name=ApiName,Value=$API_NAME Name=Stage,Value=$STAGE \
  --actions-enabled \
  --alarm-actions "$SNS_TOPIC_ARN" \
  --region "$REGION"

echo "Deploying Duration Latency Alarm..."
aws cloudwatch put-metric-alarm \
  --alarm-name "LugLinkMatchAPI-DurationExceeded" \
  --alarm-description "Triggers when API Gateway latency exceeds 3000 ms in 5 minutes" \
  --metric-name Latency \
  --namespace AWS/ApiGateway \
  --statistic Average \
  --unit Milliseconds \
  --period 300 \
  --threshold 3000 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --evaluation-periods 1 \
  --treat-missing-data notBreaching \
  --dimensions Name=ApiName,Value=$API_NAME Name=Stage,Value=$STAGE \
  --actions-enabled \
  --alarm-actions "$SNS_TOPIC_ARN" \
  --region "$REGION"

echo "✅ All alarms deployed successfully."
