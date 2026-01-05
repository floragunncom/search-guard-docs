---
title: Anomaly Detection Glossary
html_title: Anomaly Detection Glossary
permalink: anomaly-detection-glossary
layout: docs
section: anomaly_detection
edition: community
description: Technical glossary of key anomaly detection terms and concepts
---

# Anomaly Detection Glossary

This glossary provides definitions of key technical terms and concepts used throughout the Anomaly Detection documentation.

## A

**Aggregation**
: A feature aggregation method that summarizes data points, such as sum, average, or maximum values.

**Anomaly**
: A data point or pattern that significantly deviates from expected behavior, as identified by the detection algorithm.

**Anomaly Grade**
: A score indicating how anomalous a data point is, ranging from 0 (normal) to 1 (highly anomalous).

**Anomaly Score**
: A numeric value representing the degree of anomaly detected at a specific time point.

## C

**Category Field**
: A field used to split data into separate entities for multi-entity detection, such as grouping by user or host.

**Confidence Interval**
: A range of values within which the model expects normal data to fall, used to identify anomalies.

**Custom Result Index**
: A user-specified index where anomaly detection results are stored instead of the default system index.

## D

**Detector**
: A configured anomaly detection job that monitors specific features in data and identifies unusual patterns.

**Detector Interval**
: The time frequency at which the detector processes data and produces results, such as every 5 minutes.

**Detection Interval**
: The time period between consecutive anomaly detection runs for a detector.

## F

**Feature**
: A specific metric or aggregation being monitored for anomalies, such as average response time or request count.

**Feature Aggregation**
: The statistical operation applied to raw data to create features for anomaly detection.

## H

**Historical Analysis**
: Running anomaly detection on past data to identify anomalies retroactively.

**Historical Detection**
: The process of analyzing historical data to find anomalies that occurred in the past.

## I

**Index**
: The Elasticsearch index containing the source data to be analyzed for anomalies.

**Initialization Period**
: The initial time window during which the detector learns normal patterns before producing reliable anomaly scores.

## J

**Job**
: The execution instance of a detector, responsible for processing data and generating results.

## M

**Model**
: The machine learning algorithm and its learned parameters used to identify anomalies in data.

**Multi-entity Detection**
: Anomaly detection across multiple entities (such as different users or servers) using category fields.

## R

**Real-time Detection**
: Continuously analyzing incoming data to detect anomalies as they occur.

**Result**
: The output of an anomaly detection run, including anomaly scores and identified anomalies.

**Result Index**
: The index where anomaly detection results are stored.

## S

**Shingle Size**
: The number of consecutive data points combined into a single feature, used for detecting patterns over time.

**Source Index**
: The Elasticsearch index containing the raw data to be analyzed by the detector.

**Start Detector**
: The action of beginning anomaly detection, causing the detector to start processing data.

**Stop Detector**
: The action of pausing anomaly detection, halting data processing without deleting the detector.

## T

**Threshold**
: A configured value that determines when an anomaly score is significant enough to be reported or trigger an alert.

**Time Field**
: The timestamp field in the source data used to order and window data for detection.

**Training**
: The initial learning phase where the model establishes baseline patterns from historical data.

## W

**Window Delay**
: A time buffer added to account for late-arriving data before the detector processes a time window.
