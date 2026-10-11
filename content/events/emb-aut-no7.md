---
title: "Embedded AI"
date: 2026-11-12
description: "Embedded Austria No. 7: Embedded AI"
tags: ["artificial-inteligence", "machine-learning", "embedded"]
event:
  number: 7
  location: "SBA Research, Floragasse 7 - 5th floor , 1040 Vienna"
  date: "Thursday, November 12th 2026, 18:00 to 22:00 CET"
  start: 2026-11-12T18:00:00+01:00
  end: 2026-11-12T22:00:00+01:00
  venue: "SBA Research"
  street: "Floragasse 7, 5th floor"
  postal_code: "1040"
  city: "Vienna"
  country: "AT"
  price: 10
  currency: "EUR"
ticket_url: "https://www.eventbrite.at/e/embedded-austria-no-7-embedded-ai-tickets-1990323606485"
---

Embedded Austria No. 7 is dedicated to AI used in embedded systems.

Expect concrete insights, honest lessons learned, and discussion beyond marketing slides.

The evening concludes with open networking, an opportunity to continue the discussion and connect with others from the embedded community.

## Agenda

- **18:00–18:20** Event Opening
- **18:20–19:00** AI-as-a-Service in Space for Real-Time Earth Observation Intelligence - *Thomas Pusztai*
- **19:05–19:45** Edge Learning: Privacy by Design or New Attack Surface - *Rudolf Mayer, SBA Research*
- **19:50–20:30** LLM Inference Is a Memory Problem - *Jonas Vander, Xinity*
- **20:30–22:00** Open Networking


## AI-as-a-Service in Space for Real-Time Earth Observation Intelligence

*by Thomas Pusztai*

Thomas Pusztai obtained his PhD in computer science at the Distributed Systems Group of TU Wien. His research focuses on the Edge-Cloud-Space computing continuum. As co-founder and CEO of LeoTrek AI GmbH he is working on a software platform for distributed AI-as-a-Service in space to deliver intelligence for time-critical use cases.

## Edge Learning: Privacy by Design or New Attack Surface

*by Rudolf Mayer*

Most connotations of embedded AI today might consider the inference stage - the model is trained on a server and deployed to the device. Yet the data that could improve it is generated on the device, and often can’t leave it because of bandwidth, patchy connectivity or data protection. Enter Federated Edge learning: it trains on the device instead. Devices learn locally, and federated learning combines their updates without ever collecting the raw data centrally, which is why it is often described as privacy by design.

The talk starts with examples where this is worth the effort, explains how federated learning works, and then covers what is different on embedded hardware: training needs far more memory and energy than inference, devices drop out in the middle of a round, and the data on one device can look very different from the data on the next, i.e, we might have highly heterogeneous and imbalanced data.

Finally, federated edge learning is not without caveat. Sending updates instead of raw data reduces exposure, but an update can still reveal information about the data it was computed from. And because the server never sees the data behind an update, a few compromised devices can send manipulated updates that poison the model or add a backdoor.

Rudolf Mayer is a senior researcher at SBA Research, and leads the Machine Learning and Data Management team. He is also teaching at TU Wien.

He has been working in machine learning for 20 years, and tackles privacy and security in ML for the last 10 years, with a focus on federated learning, integrity and confidentiality attacks on ML, and IP Protection of ML assets like datasets and models.

## LLM Inference Is a Memory Problem

*by Jonas Vander*

*Fixed slots, paged pools and cache side channels, from edge devices to servers*

Same language model, same GPU, and yet one inference engine delivers 19 times the throughput of another. The reason is not compute power, but memory management. From an embedded perspective, this talk shows why the KV cache determines how many users and how much context a machine can handle, why fixed slots and aggressive quantisation as in llama.cpp are a good fit for a single device, and why a shared prompt cache can leak information through timing.

Jonas Vander is co-founder and CTO of Xinity, a Vienna-based sovereign AI infrastructure startup, and has spent a decade in AI engineering since studying at Radboud University. He is the architect behind the Xinity Runtime, the open-source platform that lets organisations run AI models on their own servers.
